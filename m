From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID5 - 2nd drive died whilst waiting for RMA
Date: Fri, 12 Nov 2004 12:49:15 -0500
Message-ID: <200411121749.iACHnKN01022@www.watkins-home.com>
References: <4194F38E.5060703@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4194F38E.5060703@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Greaves' <david@dgreaves.com>, 'Dick Streefland' <dick.streefland@altium.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Let me know what you have done so far.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Greaves
Sent: Friday, November 12, 2004 12:32 PM
To: Dick Streefland
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA

Dick Streefland wrote:

>David Greaves <david@dgreaves.com> wrote:
>| so, the plan in order to try and extract data:
>| * insert new drive as /dev/sdd1
>| * dd if=/dev/sda1 of=/dev/sdd1
>| * mdadm /dev/md0 --remove /dev/sda1
>| * physically swap /dev/sda and /dev/sdd so /dev/sdd
>| * mdadm /dev/md0 --add /dev/sda1
>| * fsck filesystem and expect to lose files where there were bad blocks
>| * wait for new drive (special delivery - tomorrow morning)
>| * insert new drive as /dev/sdd
>| * mdadm /dev/md0 --add /dev/sdd1
>
>You might want to check out "ddrescue", which is a version of "dd"
>that is designed to read from a disk with bad sectors.
>  
>
That was it - thanks :)

I was googling 'dd recover' and various 'badblocks' etc... not 'dd rescue'

Also found dd_rhelp which looks sensible.

fingers crossed that it works...

David

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

