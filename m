From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Impending failure?
Date: Fri, 4 Nov 2011 10:45:28 -0400
Message-ID: <CALJXSJrZziXeJa5q20KHTaM3rw3c1KU=L_pU2hLJ=km-Kh1fbQ@mail.gmail.com>
References: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com>
	<CADNH=7G7PoZxecGCbMuKohoov6TC-GyYgyCaryHaikp4oss3qw@mail.gmail.com>
	<CALJXSJouyQxMcV_CKGUiU-QkzDor2FTW25uGFyy-jDLnppnoAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALJXSJouyQxMcV_CKGUiU-QkzDor2FTW25uGFyy-jDLnppnoAg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Nov 4, 2011 at 9:57 AM, Mathias Bur=C3=A9n <mathias.buren@gmail=
=2Ecom> wrote:
>
> Basically, if uncorrectable sectors >0 or pending sectors >0 the driv=
e
> is failing. So replace ASAP :)

Exactly, with the new drives, they try to hide errors as much as they
can, as soon as SMART shows anything suspect, READ DMA failures,
pending sectors, offline uncorrectable sectors, or any tests fail, the
disk is going to die soon.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
