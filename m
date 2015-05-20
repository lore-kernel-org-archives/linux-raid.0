From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: Replacing a failed disk "in advance"
Date: Wed, 20 May 2015 17:15:58 +0200
Message-ID: <20150520151558.GV24672@fi.muni.cz>
References: <20150520142049.GT24672@fi.muni.cz>
 <20150520144001.GA2826@dev>
 <20150520145126.GU24672@fi.muni.cz>
 <CADvHm=aB2MDFxdR5Q3JBL5_WbD7oc2d99kFe4Jjbun1Lw667MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADvHm=aB2MDFxdR5Q3JBL5_WbD7oc2d99kFe4Jjbun1Lw667MQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <casparsmit@supernas.eu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Caspar Smit wrote:
: Op 20 mei 2015 16:51 schreef "Jan Kasprzak" <kas@fi.muni.cz>:
: >
: >         OK, this seems to be a way to go.
: >
: >         Unfortunately, the system in question is too old,
: > and its mdadm does not know about the --replace option, according to
: > mdadm --manage --help. So I will look for a newer mdadm and hope the old
: > kernel of that system supports the mdadm --replace.
: >
: 
: You'll need kernel version 3.3+ to support advance replacement.

	OK, I have grabbed the Fedora 22 mdadm package, rebuilt it,
and apparently mdadm --manage /dev/mdXX --replace /dev/sdOLD1 --with /dev/sdNEW1
works as expected. Thanks!

-Yenya.

-- 
| Jan "Yenya" Kasprzak   <kas at {fi.muni.cz - work | yenya.net - private}> |
| New GPG 4096R/A45477D5 -- see http://www.fi.muni.cz/~kas/pgp-rollover.txt |
| http://www.fi.muni.cz/~kas/     Journal: http://www.fi.muni.cz/~kas/blog/ |
           Smart data structures and dumb code works a lot better
           than the other way around.           --Eric S. Raymond
