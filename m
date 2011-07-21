From: Shaun Reich <predator106@gmail.com>
Subject: Re: Raid5 boot failure after grow
Date: Thu, 21 Jul 2011 11:18:57 -0400
Message-ID: <CADVynFAC3s12xveAWnJmMpY+qTZMB6qJdthiZXGuZ9t-E_xmCA@mail.gmail.com>
References: <CADVynFA9NffR7jMrN5HV05n9V0=SOVdyFQjvCvNP=MU+G-ur6g@mail.gmail.com>
 <4E260E21.5020001@turmel.org> <CADVynFDJO3_87ub-qfKK-0JWOB0nYK5P7=Au7fhcd+LEQkP=OA@mail.gmail.com>
 <4E27FA2C.9070207@oldum.net>
Reply-To: shaun.reich@kdemail.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E27FA2C.9070207@oldum.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nikolay Kichukov <hijacker@oldum.net>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yeah, / is on it. I just managed to fix it by running chroot and
dracut --mdadmconf. My issue was that I was using dracut --mdadmconf
$(uname -r)...which was trying to use the livecd's running kernel.
Right when I specified manually the newest kernel for my raid system,
it worked. Thanks.

-- 
Shaun Reich,
KDE Software Developer (kde.org)
