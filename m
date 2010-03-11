From: Carlos Mennens <carloswill@gmail.com>
Subject: Re: Configuring RAID5 w/ Spare?
Date: Thu, 11 Mar 2010 13:18:43 -0500
Message-ID: <d80f793f1003111018n3b769299m9a5bd8f4a46e2678@mail.gmail.com>
References: <d80f793f1003111011m588e1bdem3a9d934ff0fdc35e@mail.gmail.com>
	 <4B993370.2040003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B993370.2040003@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 11, 2010 at 1:16 PM, Brendan Conoboy <blc@redhat.com> wrote=
:
> Why not partition? =C2=A0It's possible to create a floating spare, bu=
t it doesn't
> really make sense for the configuration you've described. =C2=A0Just =
add
> identical partitions on sdd and include the respective partitions on =
each of
> your array creation commands.

OK so you're just saying all I should change is partition /dev/sdd as
I did the rest? I don't however need to format this when installing my
Linux O.S., correct? I should just skip formatting and mount point
assignment since it's a hot spare?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
