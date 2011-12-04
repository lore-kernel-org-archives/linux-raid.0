From: wilsonjonathan <piercing_male@hotmail.com>
Subject: Re: md metadata nightmare
Date: Sun, 4 Dec 2011 17:31:06 +0000
Message-ID: <BLU0-SMTP331AF211B9C3D0D1799003C98B40@phx.gbl>
References: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com>
	 <20111123114743.1085889e@notabene.brown>
	 <CADzwnhUJ7HbZH9yqa6x9sHFLo8Vg=1k_SyzvZyq2=iQ5YRLhZQ@mail.gmail.com>
	 <20111124093637.0c3bb2eb@notabene.brown>
	 <CADzwnhXuW7ShBNGf+kqnZYrtRnWMPSRDWzb2h4Gt69Cih0-yGA@mail.gmail.com>
	 <20111204061122.5bb5de4b@notabene.brown>
	 <CADzwnhW+o69Dum10biobv8r093uUa+LABv71Jdg+obOt5Ev6+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzwnhW+o69Dum10biobv8r093uUa+LABv71Jdg+obOt5Ev6+A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kenneth Emerson <kenneth.emerson@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> So I finished my backup and attempted to recreate the array using:
> 
> root@mythtv:/home/ken# mdadm -C /dev/md3 --metadata=1.0 --chunk=64k
> --level=6 --raid-devices=5 missing /dev/sdb4 /dev/sdc4 /dev/sda4
> /dev/sdd4 --assume-clean
> 
> and received the error:
> 
> mdadm: invalid chunk/rounding value: 64k
> 
> What do I do now?

Omit the "k" only M or G are allowed as the default is to assume K


> 
> -- Ken E.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


