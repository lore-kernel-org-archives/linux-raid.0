From: Joe Bryant <tenminjoe@yahoo.com>
Subject: Re: Spare drive won't spin down
Date: Fri, 7 May 2010 00:39:36 -0700 (PDT)
Message-ID: <312825.70015.qm@web31708.mail.mud.yahoo.com>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com> <i2j4877c76c1005062207t8c8729av6d1a1d36b9ec9365@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <i2j4877c76c1005062207t8c8729av6d1a1d36b9ec9365@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> More of a 'warm' spare; in the box, ready to kick in as soon as needed

> but otherwise spun down and idled.

Exactly so.

> If it does you should look in to creating a 'spare group' and having the 'spare'
> in that group (which should only change when it's pulled out and added
> to a different group/array).

Sounds good, but I don't see a way to do that. As far as I can tell, a "spares group" isn't a thing that exists in its own right - it's a property of an array, and arrays with a matching "spares group" property will share spare disks if necessary and possible. I'd be pleased to be wrong, let me know if I've misunderstood.

Thanks -

-- 
Joe



      
