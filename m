From: Christian Kivalo <valo@valo.at>
Subject: Re: mdadm 1.5.0, email not being sent on all events!?
Date: Wed, 25 Feb 2004 19:06:14 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040225190614.00006a42@valo.lan.valo.at>
References: <20040224234324.00004fc9@valo.lan.valo.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040224234324.00004fc9@valo.lan.valo.at>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 24 Feb 2004 23:43:24 +0100, Christian Kivalo <valo@valo.at>
wrote:

[snip]

> mdadm sends one or sometimes two emails when i manually fail a disk
> (mdadm --manage /dev/md3 --fail /dev/sda5), but it does not send email
> on the following events:
> 
> no spare left
> hotadd/rebuild
> start rebuild finished

[snip]

> could somebody please shed some light on this, testmessages function
> properly for all arrays.

hi!

sorry for replying to myself. i should have gone to sleep and not post
that message. i discovered all information i was looking for at the
bottom of the man page for mdadm. please excuse.

bye
christian

