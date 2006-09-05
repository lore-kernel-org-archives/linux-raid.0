From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Care and feeding of RAID?
Date: Tue, 5 Sep 2006 14:19:43 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net>
References: <44FD722C.7050608@waldoware.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FD722C.7050608@waldoware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 5 Sep 2006, Paul Waldo wrote:

> Hi all,
>
> I have a RAID6 array and I wondering about care and feeding instructions :-)
>
> Here is what I currently do:
>     - daily incremental and weekly full backups to a separate machine
>     - run smartd tests (short once a day, long once a week)
>     - check the raid for bad blocks every week
>
> What else can I do make sure the array keeps humming?  Thanks in advance!

Stop fiddling with it :)

I run similar stuff, but don't forget running mdadm in daemon mode to send
you an email should a drive fail. I also check each device individually,
rather than the array although I don't know the value of doing this over
the SMART tests on modern drives though...

Gordon
