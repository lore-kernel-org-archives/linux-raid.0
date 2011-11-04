From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Impending failure?
Date: Fri, 4 Nov 2011 15:59:24 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1111041557210.19721@uplift.swm.pp.se>
References: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com> <CADNH=7G7PoZxecGCbMuKohoov6TC-GyYgyCaryHaikp4oss3qw@mail.gmail.com> <CALJXSJouyQxMcV_CKGUiU-QkzDor2FTW25uGFyy-jDLnppnoAg@mail.gmail.com>
 <CALJXSJrZziXeJa5q20KHTaM3rw3c1KU=L_pU2hLJ=km-Kh1fbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1205728986-1320418764=:19721"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALJXSJrZziXeJa5q20KHTaM3rw3c1KU=L_pU2hLJ=km-Kh1fbQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1205728986-1320418764=:19721
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 4 Nov 2011, Jérôme Poulin wrote:

> Exactly, with the new drives, they try to hide errors as much as they
> can, as soon as SMART shows anything suspect, READ DMA failures,
> pending sectors, offline uncorrectable sectors, or any tests fail, the
> disk is going to die soon.

Pending sectors (READ ERROR) is not as bad as equivalent write errors.

A 2TB drive has a bit error rate meaning it'll be according to spec if it 
throws you a read error very 6 times you read all data from it.

So saying read errors and pending sectors are a strong indication of 
impending doom is an exaggeration.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1205728986-1320418764=:19721--
