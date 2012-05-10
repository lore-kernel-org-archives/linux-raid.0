From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 10:53:28 -0700
Message-ID: <otbt79xn1j.ln2@goaway.wombat.san-francisco.ca.us>
References: <4FAAE8F1.8000600@pocock.com.au>
 <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
 <4FABC7C6.4030107@turmel.org>
 <CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com>
 <4FABE724.40103@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-05-10, Phil Turmel <philip@turmel.org> wrote:
>
> Frequent array checks are not optional, if you want flush out any UREs
> in the making, and maximize your odds of successfully rebuilding after
> a drive replacement.  If you are running RAID6 or a triple mirror, with
> frequent checks, you are very safe.

How frequent do people define as "frequent"?  I typically do monthly
checks, but perhaps I should be doing them weekly.

--keith


-- 
kkeller@wombat.san-francisco.ca.us


