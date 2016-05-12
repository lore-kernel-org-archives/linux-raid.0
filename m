From: Phil Turmel <philip@turmel.org>
Subject: Re: recovering failed and unrecognizable RAID5 during mdadm --grow
 without backup
Date: Thu, 12 May 2016 14:58:05 -0400
Message-ID: <5734D23D.6030400@turmel.org>
References: <1b26650f-0b2c-2485-f781-e3fd26340741@misalpina.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1b26650f-0b2c-2485-f781-e3fd26340741@misalpina.net>
Sender: linux-raid-owner@vger.kernel.org
To: Claudiu Rad <jazzman@misalpina.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/12/2016 02:22 AM, Claudiu Rad wrote:
> hello all,

Please show the examine for the individual partitions of the raid5:

mdadm --examine /dev/sd[a-d]3

{ Replace the '3' if appropriate.  You don't say what partition numbers
your raid5 is on. }

You will need to manually assemble (not create !) your array with a
backup file outside the raid5, and the --invalid-backup option to
abandon the backup file you can't get to.  You will likely have some
unavoidable corruption at the reshape position due to this.

Phil
