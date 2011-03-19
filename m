From: Xavier Brochard <xavier@alternatif.org>
Subject: Re: disk order problem in a raid 10 array
Date: Sat, 19 Mar 2011 01:05:58 +0100
Message-ID: <201103190105.59075.xavier@alternatif.org>
References: <201103181549.20835.xavier@alternatif.org> <20110319102039.52cc2282@notabene.brown> <201103190059.08093.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103190059.08093.xavier@alternatif.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le samedi 19 mars 2011 00:59:07 Xavier Brochard, vous avez =E9crit :
> > Could you please sent a complete output of:
> >=20
> >    cat /proc/mdstat
> >    mdadm -D /dev/md0
> >    mdadm -E /dev/sd?1
> >=20
> >
> > all collected at the same time.  Then I will suggest if there is an=
y
> > action you should take to repair anything.
>=20
> Here it is, thankyou for you help

don't now if it is important, but I collected them from Sysrescue-cd, w=
ith a=20
2.6.35-std163-amd64 kernel

Xavier
xavier@alternatif.org - 09 54 06 16 26
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
