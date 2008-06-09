From: Gavin Hamill <gdh@acentral.co.uk>
Subject: [SOLVED] Re: Rebuild after a drive replacement
Date: Mon, 09 Jun 2008 19:56:07 +0100
Message-ID: <1213037767.6233.17.camel@gdh-home>
References: <1212958349.7596.14.camel@gdh-home>
	 <38060.192.168.1.70.1212963930.squirrel@neil.brown.name>
	 <1212999164.15461.2.camel@gdh-work>
	 <32774.192.168.1.70.1213002278.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <32774.192.168.1.70.1213002278.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2008-06-09 at 19:04 +1000, NeilBrown wrote:


> So: you might need to repartition the drive and make hde5 a
> little bigger.

Yup, that was precisely it. Rebooted to refresh the updated partition
table, ran  mdadm --add /dev/md3 /dev/hde5 and it's happily rebuilding
as I write. Now I'll be a little better armed when the next drive fails
(smartctl is already showing the signs...)

Hurrah!

Cheers,
Gavin.


