From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: possibly silly configuration question
Date: Thu, 27 Dec 2012 11:44:54 -0500
Message-ID: <50DC7B06.1040105@meetinghouse.net>
References: <50DBCB88.5070408@meetinghouse.net> <50DBD1E5.8000206@websitemanagers.com.au> <50DC710E.7040402@meetinghouse.net> <50DC7584.4030701@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50DC7584.4030701@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Adam Goryachev wrote:
> On 28/12/12 03:02, Miles Fidelman wrote:
>> Adam,
>>
>> Thanks for the suggestions.  The thing I'm worried about is how much
>> traffic gets generated as I start wiring together more complex
>> configurations, and the kind of performance hits involved
>> (particularly if a node goes down and things start getting re-syncd).
>>
> With my suggested config, I'd put 2 x Gb ethernet from each machine on
> one vlan, and the other two from each to the network. (Actually, what is
> you're bandwidth to the end user? If these are Internet services, you
> probably don't need 2 x Gb connections, so use 3Gb for the storage, and
> 1Gb for the end user facing network).

Yup.  I have 4 gigE ports on each box - so I was thinking 2 for storage, 
2 for outside - giving me full redundancy (I have two separate outside 
connections for the cluster).
>
> Do you actually know what the workload will be ? 

Not really.  I have a mix of production email/listserv/web/database on 
one VM (relatively low load), a backup server on a second VM, and the 
rest of the cluster is used for a mix of development and test for some 
new service development.  Short term, load will be low, but could start 
spiking quickly.  My other task is designing for rapid expansion - first 
through AWS, then through more hardware.

Thanks Again,

Miles


-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra

