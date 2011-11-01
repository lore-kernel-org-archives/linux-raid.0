From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 01 Nov 2011 09:02:52 -0400
Message-ID: <4EAFEDFC.8090001@meetinghouse.net>
References: <4EAF3F78.5060900@meetinghouse.net> <20111101092659.GA12805@vault>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111101092659.GA12805@vault>
Sender: linux-raid-owner@vger.kernel.org
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Johannes Truschnigg wrote:
> Hi Miles,
>
> On Mon, Oct 31, 2011 at 08:38:16PM -0400, Miles Fidelman wrote:
>> Hi Folks,
>>
>> I've been exploring various ways to build a "poor man's high
>> availability cluster."  Currently I'm running two nodes, using raid
>> on each box, running DRBD across the boxes, and running Xen virtual
>> machines on top of that.
>> [...]
> while I do note that I don't answer your question at hand, I'm still inclined
> to ask if you do know Ganeti (http://code.google.com/p/ganeti/) yet? It offers
> pretty much everything you seem to want to have.

Actually I do know Ganeti, and it does NOT come close to what I'm 
suggesting:
- it supports migration but not auto-failover
- DRBD is the only mechanism it provides for replicating data across 
nodes - which limits migration to a 2-node pair




-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


