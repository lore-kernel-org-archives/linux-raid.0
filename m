From: Philip Molter <philip@corp.texas.net>
Subject: Re: The right way to recover from md partition failure?
Date: Mon, 30 Aug 2004 17:17:13 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4133A769.5090408@corp.texas.net>
References: <200408302014.i7UKEU306097@watkins-home.com> <41339D1D.2040101@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41339D1D.2040101@dgreaves.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> I think a better approach might be:
> 
> mdadm /dev/md1 -r /dev/hde3
> dd if=/dev/hde3 of=/dev/null
> check logs for nasty errors and only continue if there weren't any :)
> mdadm /dev/md1 -a /dev/hde3

Normally, for this I:

dd if=/dev/zero of=/dev/hde3
dd if=/dev/hde3 of=/dev/null

The write will usually cause the hard drive to internally relocate any 
bad sectors, which is usually what causes RAID failures on IDE drives 
(in my experience).
