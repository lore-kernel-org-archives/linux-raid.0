From: "Ruth Ivimey-Cook" <Ruth.Ivimey-Cook@ivimey.org>
Subject: Effect of Stripe Size  (was Postgres on RAID5)
Date: Tue, 15 Mar 2005 16:17:55 -0000
Message-ID: <20050315161838.B4FC2568C4@svr1.postgresql.org>
References: <200503142349.j2ENnG510033@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503142349.j2ENnG510033@www.watkins-home.com>
Sender: pgsql-performance-owner@postgresql.org
To: 'Guy' <bugzilla@watkins-home.com>, 'Michael Tokarev' <mjt@tls.msk.ru>, 'Arshavir Grigorian' <ag@m-cam.com>
Cc: linux-raid@vger.kernel.org, pgsql-performance@postgresql.org
List-Id: linux-raid.ids

Folks,

> You said:
> "If your write size is smaller than chunk_size*N (N = number 
> of data blocks in a stripe), in order to calculate correct 
> parity you have to read data from the remaining drives."
> 
> Neil explained it in this message:
> http://marc.theaimsgroup.com/?l=linux-raid&m=108682190730593&w=2

Having read that and the recent posts:

Has anyone done any performance checks on the md code to determine what, if
any, effect the stripe size has on performance? One might suppose the variables
would be stripe size, file size and read vs write. Possibly number of drives in
array, too.

Reason for asking:

When I set up my raid5 array, I chose a stripe of 256K, on the grounds that a
large number of the files on the drive are multi-megabytes (fairly evenly in
the 20MB - 100MB range) and I supposed that a large stripe would speed things
up for those files. Was I right?

Regards,

Ruth



---------------------------(end of broadcast)---------------------------
TIP 4: Don't 'kill -9' the postmaster
