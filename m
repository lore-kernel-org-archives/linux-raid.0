From: Lajber Zoltan <lajbi@lajli.gau.hu>
Subject: Re: Question regarding mdadm.conf
Date: Thu, 17 Feb 2005 07:48:46 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0502170748160.15568@lajli.gau.hu>
References: <421438E9.5020000@gmx.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <421438E9.5020000@gmx.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Torsten E." <linux-user@gmx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

On Thu, 17 Feb 2005, Torsten E. wrote:

> How does I get those UUID information, to add them to the new
> /etc/mdadm.conf?

Try this one: mdadm --detail /dev/md1 | grep UUID

Bye,
-=Lajbi=----------------------------------------------------------------
 LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
   engineer: a mechanism for converting caffeine into designs.

