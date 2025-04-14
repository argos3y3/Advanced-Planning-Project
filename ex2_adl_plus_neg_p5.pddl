(define (problem ex2_adl_plus_neg_p5)
    (:domain ex2_adl_plus_neg)
    ; OBJECT DEFINITION
    (:objects
       depot1 - depot ;; our initial depot1
       location1 location2 - location ;; other location avaiable
       robot1 - robot ;; our agent
       box1 - box ;; three box avaiable
       person1 person2 person3 - person ;; person to be rescued
       ; content to be delivered
       content1 content4 - food
       content2 content5 - tool
       content3 content6 - medicine
       ; carrier
       carrier1 - carrier
    )
    ; PREDICATE DEFINITION    
    (:init
        ; all box, content, agent at depot1 initially
        ; box initial position
        (be_at_box box1 depot1)
        ; content initial position
        (be_at_content content1 depot1)
        (be_at_content content2 depot1)
        (be_at_content content3 depot1)
        (be_at_content content4 depot1)
        (be_at_content content5 depot1)
        (be_at_content content6 depot1)
        ; robot initial position
        (be_at_robot depot1 robot1)
        ; people initial position
        (be_at_person location1 person1)
        (be_at_person location2 person2)
        (be_at_person location2 person3)
       
        ; set capacity
        (carrier_capacity_4 carrier1)
        ; assign carrier
        (assigned_robot_carrier  carrier1 robot1)
    )
    ; GOAL DEFINITION
    (:goal
        (and
		(or
		    (assigned_person_content content1 person1)
		    (assigned_person_content content4 person1)
		)
		(or
		    (assigned_person_content content2 person2)
		    (assigned_person_content content5 person2)
		)
		(or
		    (assigned_person_content content3 person3)
		    (assigned_person_content content6 person3)
		)
        )
    )
)
