(define (problem ex1_strip_plus_neg_p9)
    (:domain ex1_strip_plus_neg)
    ; OBJECT DEFINITIONS
    (:objects
       depot - location ;; our initial depot
       location1 location2 location3 location4  - location ;; other location avaiable
       robot1 - robot ;; our agent
       box1 box2 box3 box4 - box ;; three box avaiable
       person1 person2 person3 person4 - person ;; person to be rescued
       ; content to be delivered
       content1 content4 content7 content10 - food
       content2 content5 content8 content11 - tool
       content3 content6 content9 content12 - medicine
    )
    ; PREDICATE DEFINITIONS    
    (:init
        ; all box, content, agent at depot initially
        ; box initial position
        (be_at_box box1 depot)
        (be_at_box box2 depot)
        (be_at_box box3 depot)
        (be_at_box box4 depot)
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
        (be_at_content content10 depot)
        (be_at_content content11 depot)
        (be_at_content content12 depot)
        ; robot initial position
        (be_at_robot depot robot1)
        ; people initial position
        (be_at_person location1 person1)
        (be_at_person location2 person2)
        (be_at_person location3 person3)
        (be_at_person location4 person4)
        ; note that robot and box must be empty
        (empty_robot robot1)

        ; box initial empty
        (empty_box box1)
        (empty_box box2)
        (empty_box box3)
        (empty_box box4)
       
    )
    ; GOAL DEFININTIONS
    (:goal
        (and
		; deliver food
		(or
		    (assigned_person_content content1 person1)
		    (assigned_person_content content4 person1)
		    (assigned_person_content content7 person1)
		    (assigned_person_content content10 person1)
		)
		(or
		    (assigned_person_content content1 person2)
		    (assigned_person_content content4 person2)
		    (assigned_person_content content7 person2)
		    (assigned_person_content content10 person2)
		)
		; deliver tool
		(or
		    (assigned_person_content content2 person1)
		    (assigned_person_content content5 person1)
		    (assigned_person_content content8 person1)
		    (assigned_person_content content11 person1)
		)
		(or
		    (assigned_person_content content2 person3)
		    (assigned_person_content content5 person3)
		    (assigned_person_content content8 person3)
		    (assigned_person_content content11 person3)
		)
		; deliver medicine
		(or
		    (assigned_person_content content3 person1)
		    (assigned_person_content content6 person1)
		    (assigned_person_content content9 person1)
		    (assigned_person_content content12 person1)
		)
		(or
		    (assigned_person_content content3 person4)
		    (assigned_person_content content6 person4)
		    (assigned_person_content content9 person4)
		    (assigned_person_content content12 person4)
		)
	)
           
    )
)
