From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: I am an idiot (power failure during chunk resize, no backup file)
Date: Thu, 4 Mar 2010 14:51:21 +0100
Message-ID: <201003041451.21279.thomas.jarosch@intra2net.com>
References: <68c4f7e31003040437u233f8eb6q6d7351dba50578be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <68c4f7e31003040437u233f8eb6q6d7351dba50578be@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alex,

On Thursday, 4. March 2010 13:37:54 you wrote:
> Yes I am using LVM.  I'm not entirely sure how to go about messing
> with the mounting as you describe, I've never had to do it.  Is this
> with the mount command?  I do keep getting an error from lvm,
> "incorrect metadata area header checksum", with both chunk=64 and
> chunk=256 during the recreate.

Try to create a raw copy of those discs if your budget allows it
before you start fooling around. That way you won't damage
the real array any further and you can "experiment".
Your data should be worth it.

Cheers,
Thomas
