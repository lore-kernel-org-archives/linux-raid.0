From: Danilo Godec <danci@agenda.si>
Subject: Re: Multiple disk failure - recover?
Date: Wed, 10 Jul 2002 15:43:58 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0207101542380.25329-100000@duplo.agenda.si>
References: <15660.14403.330548.476141@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15660.14403.330548.476141@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 10 Jul 2002, Neil Brown wrote:

>  mdadm --assemble --force /dev/md1 /dev/sda2 /dev/sdc2
>
> Then it will have to use a2 and c2.

I tried that, but it refused to do it (something about 2/3 drives
failed)!? Maybe my mdadm version is old (v1.0.0)?

   D.


