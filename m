From: Drew <drew.kay@gmail.com>
Subject: Re: when does a raid rebuild failed
Date: Tue, 3 Aug 2010 12:13:36 -0700
Message-ID: <AANLkTinEjRoa37rNO-dTSVpVDz+aZHC_FYQ8-Sb7TvGz@mail.gmail.com>
References: <4C5836A2.3000809@eisoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C5836A2.3000809@eisoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I am using mdadm to create raid on a jbod. Sometimes the rebuild process
> of the raid failed, and some of the active disks became faulty.
> Does someone konwns when a disk will become faulty?

Running 'smart' on a disk in the jobd will tell you if the disk itself
is showing signs of becoming faulty. There are also other possible
causes, including controller failure and bad cables. I'd need more
information about what exactly is failing, and how, before I can give
you a better answer.

> How does a raid that is created by mdadm failed?

Usually because a drive failed. See my previous answer for why.

> What is the process of the raid that is rebuilding.

Not sure what you mean. We need a bunch more information about what is
failing, logs showing what is happening, etc before we can really
begin to offer any answers.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
