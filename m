From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 10:05:56 +0100
Message-ID: <20050319090556.GK18819@marowsky-bree.de>
References: <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <20050318171608.GA28494@percy.comedia.it> <423B4C4B.7070404@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <423B4C4B.7070404@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>, Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-19T00:46:51, Michael Tokarev <mjt@tls.msk.ru> wrote:

> o DRBD allows local drive to be a bit ahead compared to remote one
>  (configurable), while md will wait for all drives to complete a writ=
e.

The async writes have been added to md recently my Paul too.

> There's a case which is questionable in the first place: what to
> do if local part of the mirror fails?  Md will happily run on
> single remote component in degraded mode, while DRBD will probably
> fail...=20

drbd will continue correctly; it'll detach the local drive and run all
IO over the network. Also, the direction of the sync has been decoupled
from the primary/secondary status for a while, and the drbd-0.8
(development branch) is almost 90% there to allow both nodes IO access
to the device.

(I think; maybe it's also already done. It's been a while since I tried
playing with that particular version.)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
