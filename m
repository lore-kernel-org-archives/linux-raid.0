From: Arun Khan <knura9@gmail.com>
Subject: Re: CentOS 6.2 on partition able RAID1 (md_d0) - kernel panic with
 either disk not present
Date: Mon, 15 Oct 2012 16:10:59 +0530
Message-ID: <CAHhM8gAe56TC4w_d-SM2Zm4jgYh4gKmUXzY9Ko1YP2RqQ=33Cg@mail.gmail.com>
References: <CAHhM8gBsxgYUwqOiVePKFb-epbTQwZDRH50HQy9PPaOMOY=Brw@mail.gmail.com>
	<506C4A73.6050504@anonymous.org.uk>
	<CAHhM8gDS+n6q+KSMvA0y1SAMLKrLzOhjCQVx63FoJ+_JVYjDGw@mail.gmail.com>
	<CAHhM8gAOfUXwPet1EY3gBa_9--K2opvEYFmOxBh9KJnHSCr_Hw@mail.gmail.com>
	<50714622.4020903@anonymous.org.uk>
	<CAHhM8gBhEj2EK4oJr-Na7OYjymePYY+Lh5nKH3=R+GkMFcBaNw@mail.gmail.com>
	<CAHhM8gCL1rnc6g8jEhMvz_jPTGX3SL+9LuBLsZBOg7tGO2WyTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHhM8gCL1rnc6g8jEhMvz_jPTGX3SL+9LuBLsZBOg7tGO2WyTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

___ SOLVED ___

After experimenting with the boot loader changes (without any success
in solving the problem), I did some search on the other suspect
'dracut,' replacement for mkinitrd in RHEL/CentOS 6.

There were two bug reports on the tool (6.2 and 6.3).

I updated dracut to dracut-004-284.el6_3.1.noarch and that fixes the problem.

Details on the procedure posted in the CentOS mailing list.
Ref. <http://lists.centos.org/pipermail/centos/2012-October/129654.html>

Thanks to all who helped.

-- Arun Khan
