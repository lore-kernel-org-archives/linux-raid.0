From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Auto replace disk
Date: Wed, 8 Mar 2017 18:17:45 +0000
Message-ID: <58C04AC9.9070801@youngman.org.uk>
References: <CAJH6TXgyOEE5A8TZVZy-db+tPD1QeHtnXXO3B-1vmKe4cAt6xA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXgyOEE5A8TZVZy-db+tPD1QeHtnXXO3B-1vmKe4cAt6xA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/03/17 11:28, Gandalf Corvotempesta wrote:
> Hi to all
> I'm trying to configure mdadm to do automatic replace/rebuild when a
> disk is phisically removed and replaced in a slot but without success

Do you mean you remove an old disk, and put a new blank disk in?
> 
> Is this possible? How?
> The new disk must be formatted or mdadm will replicate partition table
> on it's own?

If that's what you mean, then no, it's not possible. mdadm doesn't have
a clue about disks, what it sees is "block devices".

If you stick a new disk in, you need to tell mdadm about it. At which
point you can add it as a spare (which means mdadm will use it to
replace a disk that fails), or you can tell mdadm to replace a failed disk.

You should not - if you can help it - ever remove a disk and then
replace it. Yes in practice I know that's a luxury people often don't
have ... at best you should have spares configured; if you have to you
put the new drive in, use --replace, and then remove the old one. The
last resort is to remove the broken drive and then replace it - this is
likely to trigger further failures and bring down the array.

Cheers,
Wol

