function pi_pq = SI_moment(img,p,q)
%% Calculates the Scale invariant moment given the (p+q) moment

    miu_00 = centralmoment(img,0,0); % the area
    miu_pq = centralmoment(img,p,q);

    pi_pq = miu_pq / (miu_00^(1+(p+q)/2));