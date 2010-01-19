From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [[Patch mdadm] 1/5] Make the IMSM_DEVNAME_AS_SERIAL option work
	when creating containers. This allows a person to testing using loopback
	devices that don't support serial number queries.
Date: Mon, 18 Jan 2010 22:47:33 -0700
Message-ID: <e9c3a7c21001182147o487e5f7ar7b474766d538580f@mail.gmail.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	 <1263242294-5353-2-git-send-email-dledford@redhat.com>
	 <e9c3a7c21001181413p60e0322byd97844d3f30a0715@mail.gmail.com>
	 <4B55112F.4090403@redhat.com>
	 <e9c3a7c21001182042k1a88e21fpc64ff0bb75ff5854@mail.gmail.com>
	 <4B5543CC.3060901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B5543CC.3060901@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 18, 2010 at 10:31 PM, Doug Ledford <dledford@redhat.com> wr=
ote:
> Ah, OK. =A0I did say we had been carrying this around in our SRPM for=
 a
> while, I just hadn't tried removing it since it was necessary.

No worries, I suspected as much.

> I take
> it you are implying that that changeset is the one that rendered it n=
o
> longer necessary?

Nah, this is just a recent point before Neil applied this patch.  I
did a quick look for the commit that fixed this, but nothing popped
out.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
