From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Wed, 23 Mar 2005 21:31:25 +0100
Message-ID: <20050323203125.GD26683@percy.comedia.it>
References: <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es> <423EF12A.4030207@steeleye.com> <20050321185606.GA27541@percy.comedia.it> <423F2780.5000601@steeleye.com> <20050322093525.GL7040@percy.comedia.it> <8275h2-sn4.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8275h2-sn4.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 22, 2005 at 11:02:16AM +0100, Peter T. Breuer wrote:
>Luca Berra <bluca@comedia.it> wrote:
>> If we want to do data-replication, access to the data-replicated device
>> should be controlled by the data replication process (*), md does not
>> guarantee this.
>
>Well, if one writes to the md device, then md does guarantee this - but
>I find it hard to parse the statement. Can you elaborate a little in
>order to reduce my possible confusion?

I'll try
in fault tolerant architechture where we have two systems each with a
local storage which is exposed to the other system via nbd or similar.
One node is active and writes data to an md device composed from the
local storage and the nbd device.
The other node is stand-by and ready to take the place of the former in
case it fails.
I assume the data replication is synchronous at the moment (the write system
call returns when io has been submitted to both the underlying devices) (*) 

we can have a series of failures which must be accounted for and dealt
with according to a policy that might be site specific.

A) Failure of the standby node
  A.1) the active is allowed to continue in the absence of a data replica
  A.2) disk writes from the active should return an error.
  we can configure this setting in advance.

B) Failure of the active node
  B.1) the standby node takes immediately ownership of data and resumes
  processing
  B.2) the standby node remains idle

C) communication failure between the two nodes (and we don't have an
external mechanism to arbitrate the split brain condition)
  C.1) both system panic and halt
  C.2) A1 + B2
  C.3) A2 + B2
  C.4) A1 + B1
  C.5) A2 + B1 (which hopefully will go to A2 itself)

D) communication failure between the two nodes (admitting we have an
external mechanism to arbitrate the split brain condition)
  D.1) A1 + B2
  D.2) A2 + B2
  D.2) B1 then A1
  D.3) B1 then A2

E) rolling failure (C, then B)

F) rolling failure (D, then B)

G) a failed nodes is restored

H) a node (re)starts while the other is failed

I) a node (re)starts during C

J) a node (re)starts during D

K) a node (re)starts during E

L) a node (re)starts during F

scenarios without a sub-scenarios are left as an exercise to the reader,
or i might find myself losing a job :)

now evaluate all scenarios under the following drivers:
1) data availability above all others
2) replica of data above all others
3) data availability above replica, but data consistency above
availability

(*) if you got this far, add asynchronous replicas to the picture.

Regards,
Luca

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
