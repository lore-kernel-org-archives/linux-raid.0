From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 13:28:08 -0500
Message-ID: <200501051828.j05ISE926631@www.watkins-home.com>
References: <qgnta2-mqm.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <qgnta2-mqm.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think that is in some boot-up scripts!  :)
But only if you don't have mirrors!  :)

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Peter T. Breuer
Sent: Wednesday, January 05, 2005 1:16 PM
To: linux-raid@vger.kernel.org
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
crashing repeatedly and hard)

David Greaves <david@dgreaves.com> wrote:
> Haven't you seen the special 'make_undetectable_error(float p)' function?

 dd if=/dev/urandom of=/dev/hda1 bs=512 count=1 skip=$RANDOM

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

