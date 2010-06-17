From: Neil Brown <neilb@suse.de>
Subject: Re: RAID10 n1 layout?
Date: Thu, 17 Jun 2010 20:17:34 +1000
Message-ID: <20100617201734.6fc769f3@notabene.brown>
References: <268626.87856.qm@web32401.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <268626.87856.qm@web32401.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adrian Sandor <aditsu@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 17 Jun 2010 03:02:09 -0700 (PDT)
Adrian Sandor <aditsu@yahoo.com> wrote:

> Hi, I've just created a RAID10 with mdadm using default options, and with -v it said:
>     mdadm: layout defaults to n1
> According to the docs, the default should be n2, and n1 would mean no redundancy (like RAID0)
> Furthermore, after creating the array, I checked it with -D and it said:
>     Layout : near=2
> Is this a bug?
> I'm using mdadm 3.0

Yes it is a bug.  It says "n1" but it means "n2".

It will be fixed in the next release.

Thanks for the report.

NeilBrown

> 
> Thanks
> Adrian
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

