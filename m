From: Danilo Godec <danci@agenda.si>
Subject: Re: Bad block on IDE drive causes it to be kicked out of the array
Date: Mon, 8 Jul 2002 12:26:36 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0207081224340.22860-100000@duplo.agenda.si>
References: <001f01c22632$ad349580$0200a8c0@gandalf>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001f01c22632$ad349580$0200a8c0@gandalf>
To: Chris Chabot <chabotc@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 8 Jul 2002, Chris Chabot wrote:

> is there any way to create the array, and just mark these blocks bad in the
> file system, as you would with a 'normal' drive?

Not on RAID5. At least no easy way... You could possibly find out which
filesystem blocks lay on the physically bad blocks and you could probably
mark them as bad on the filesystem level.

   D.

