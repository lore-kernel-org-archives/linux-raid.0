From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Tue, 5 Nov 2013 12:37:57 +0200
Message-ID: <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5278C2A6.7060005@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These are brand-new drives, that had fully synced some 20 hours before the array broke this morning, no problems with SMART stats or in OS logs. So, I'm fairly confident that the drives are OK.

Thanks for the detailed reply. I'm going to read a man page for all those arguments.  Meanwhile, I'm wondering if there's still a chance to assemble the array without a complete resync? It would take some 30 hrs with these drives and I'd rather avoid that, besides event count difference seems very small and I can see a lot of people say it is safe to add a non-fresh drive back in that case?

Could somebody please comment on this?

Ivan

On Nov 5, 2013, at 12:04 PM, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:

> Personally, I'd probably do something like:
> mdadm --assemble /dev/md0 /dev/sdd1
> mdadm --manage /dev/md0 --run
> mdadm --manage /dev/md0 --add /dev/sdc1
> 
> This will cause a full sync from sdd1 to sdc1, which will then ensure
> both copies are identical/up to date.
> 
> Personally, I would also do:
> mdadm --grow /dev/md0 --bitmap=internal
> This means next time you have a similar issue, when you add the older
> drive, it will only sync the small parts of the drive that are out of
> date, instead of the entire drive.
> 
> Note: The above assumes that both drives are fully functional. If you
> get a read error on sdd1 during the resync, then you will have
> additional problems.
> 
> Regards,
> Adam

