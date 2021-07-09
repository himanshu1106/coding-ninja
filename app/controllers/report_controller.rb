class ReportController < ApiController

    def ta_stats
      @all_teaching_assistants = User.active.teaching_assistant.pluck(:id, :first_name).to_h
      @overall_stats, @ta_vs_stats_hash = get_all_stats_data
    end

end
