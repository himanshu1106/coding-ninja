module ReportHelper

  def get_all_stats_data
    overall_stats = {}
    overall_stats["total_doubts"] =  Doubt.all.size
    overall_stats["doubts_solved"] = Doubt.solved.size
    overall_stats["doubts_escalated"] = DoubtTaMapping.get_escalated_count
    ta_vs_stats_hash = get_ta_vs_stats_hash
    overall_stats["avg_time"] = seconds_to_duration(ta_vs_stats_hash.values.pluck("total_time").sum/ overall_stats["doubts_solved"] )
    return overall_stats, ta_vs_stats_hash
  end

  def get_ta_vs_stats_hash
    doubt_vs_status_count  = DoubtTaMapping.select("solver_id, status,  count(*) as count_req, avg(updated_at - created_at) as avg_time").group(:solver_id, :status).as_json
    ta_vs_stats_hash = {}
    doubt_vs_status_count.each do |doubt_detail|
      solver_id = doubt_detail["solver_id"]
      doubt_status = doubt_detail["status"]
      ta_vs_stats_hash[solver_id] = ta_vs_stats_hash[solver_id] || {}
      ta_vs_stats_hash[solver_id][doubt_status] = doubt_detail["count_req"]
      ta_vs_stats_hash[solver_id]["total_time"] = ta_vs_stats_hash[solver_id]["total_time"] || 0
      if doubt_status == "done"
        ta_vs_stats_hash[solver_id]["total_time"] += (doubt_detail["count_req"] * doubt_detail["avg_time"])
      end
    end
    ta_vs_stats_hash.each do |solver_id, stats_hash|
      total_time = stats_hash["total_time"]
      doubts_solved = stats_hash["done"]
      total_doubts = stats_hash["done"].to_i + stats_hash["escalated"].to_i + stats_hash["active"].to_i
      ta_vs_stats_hash[solver_id]["total"] = total_doubts
      ta_vs_stats_hash[solver_id]["average_time"] = seconds_to_duration(total_time/doubts_solved)
    end
    ta_vs_stats_hash
  end


  def seconds_to_duration(seconds)
    minutes = seconds/60
    seconds = seconds % 60
    hours = minutes/60 
    minutes = minutes % 60 
    days = hours/24
    hours = hours % 24
    duration_string = ""
    if days != 0
      duration_string += "#{days} Days"
    end

    if days!=0 || hours != 0 
      duration_string += "#{hours} Hr "
    end

    if days!=0 || hours !=0 || minutes != 0
      duration_string += "#{minutes} Min"
    end

    duration_string
  end
end
