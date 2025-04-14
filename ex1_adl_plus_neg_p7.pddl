(define (problem ex1_adl_plus_neg_p7)
    (:domain ex1_adl_plus_neg)
    ; OBJECT DEFINITION
    (:objects
       depot - location ;; our initial depot
       location1 location2 - location ;; other location avaiable
       robot1 - robot ;; our agent
       box1 box2 box3 box4 box5 box6 - box ;; three box avaiable
       person1 person2 person3 - person ;; person to be rescued
       ; content to be delivered
       content1 content4 content7 - food
       content2 content5 content8 - tool
       content3 content6 content9 - medicine
    )
    ; PREDICATE DEFINITION   
    (:init
        ; all box, content, agent at depot initially
        ; box initial position
        (be_at_box box1 depot)        
        (be_at_box box2 depot)
        (be_at_box box3 depot)
        (be_at_box box4 depot)
        (be_at_box box5 depot)
        (be_at_box box6 depot)
        ; content initial position
        (be_at_content content1 depot)
        (be_at_content content2 depot)
        (be_at_content content3 depot)
        (be_at_content content4 depot)
        (be_at_content content5 depot)
        (be_at_content content6 depot)
        (be_at_content content7 depot)
        (be_at_content content8 depot)
        (be_at_content content9 depot)
        ; robot initial position
        (be_at_robot depot robot1)
        ; people initial position
        (be_at_person location1 person1)
        (be_at_person location2 person2)        
    )
    ; GOAL DEFINITION
    (:goal
        (and
		; deliver food
		(or
		    (assigned_person_content content1 person1)
		    (assigned_person_content content4 person1)
		    (assigned_person_content content7 person1)
		)
		(or
		    (assigned_person_content content1 person2)
		    (assigned_person_content content4 person2)
		    (assigned_person_content content7 person2)
		)
		; deliver tool
		(or
		    (assigned_person_content content2 person1)
		    (assigned_person_content content5 person1)
		    (assigned_person_content content8 person1)
		)
		(or
		    (assigned_person_content content2 person2)
		    (assigned_person_content content5 person2)
		    (assigned_person_content content8 person2)
		)
		; deliver medicine
		(or
		    (assigned_person_content content3 person1)
		    (assigned_person_content content6 person1)
		    (assigned_person_content content9 person1)
		)
		(or
		    (assigned_person_content content3 person2)
		    (assigned_person_content content6 person2)
		    (assigned_person_content content9 person2)
		)
	)
           
    )
)
