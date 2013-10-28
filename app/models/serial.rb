class Serial < Show
	has_many :seasons

	has_many :reviews, as: :reviewable


	def to_param
        [id,name.parameterize].join("-")
    end

    def self.find(input)
    	find_by(id: input.split("-")[0])
    end

end
