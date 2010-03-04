From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID MIA. Again. (Kinda.)
Date: Thu, 4 Mar 2010 14:24:11 -0800
Message-ID: <4877c76c1003041424mb25a77ewbfe6a6b5846a2f17@mail.gmail.com>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
	 <20100305075016.51e98363@notabene.brown>
	 <b305ada429c44b2b62b03c101f7ecf0a.squirrel@webmail.jots.org>
	 <4877c76c1003041421s42717938he6567434b74ec125@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003041421s42717938he6567434b74ec125@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 4, 2010 at 2:21 PM, Michael Evans <mjevans1983@gmail.com> w=
rote:
> Try providing the output of;
> for ii in /dev/[sh]d[a-z] ; do parted $ii print ; done
>
> If you have any kind of partition table this should tell us what it
> is. =A0If you don't, something odd is happening.
>

Also, you'll need to run that as the root (unix term for absolute
administrator account) user.  Since you mentioned installing and lack
partitions you probably need a linux on CD or usb stick distribution;
http://www.sysresccd.org/Main_Page works well for me and might help
you enough to get you in to user mode; as well as non-destructively
auto-detecting most storage setups and having very recent software.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
