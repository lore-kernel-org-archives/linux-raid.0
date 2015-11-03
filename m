From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: Advice requested
Date: Wed, 4 Nov 2015 02:49:53 +1100
Message-ID: <5638D7A1.6050407@websitemanagers.com.au>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
 <56367C33.6060703@turmel.org>
 <CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
 <5637842D.1070000@turmel.org>
 <CAPpdf59MFX1oVwLC-bmQBaQp9K_9-+h0v64OGMnV1-k=eCzO0w@mail.gmail.com>
 <5637BCE4.8000006@turmel.org>
 <CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
 <5637FBAC.8000900@turmel.org>
 <CAPpdf59mkRiyNYF1dT6Xp9tcofTU8hOdih+tz+i=wPJfRQrTnQ@mail.gmail.com>
 <56380690.5030600@turmel.org>
 <CAPpdf5-HbrFESY_zhfkZ4=2CtYjgO4bA4LmA+1AHkT+Gv9iY2w@mail.gmail.com>
 <56381406.7070608@turmel.org>
 <CAPpdf59EV2TfpHUiZghAfWW6qy5je686Hg_qAs4xLchrUa=G7w@mail.gmail.com>
 <5638336E.4030400@turmel.org>
 <CAPpdf5-DMFrKRiBXjstJkvqQU1KzqJoL=hfNVqTGjy2HfMcALQ@mail.gmail.com>
 <56383C64.2070807@turmel.org>
 <CAPpdf58=f7YVej5MEFgaw6KvCgn+WBcm=JSrTNbM8AixWdpa1g@mail.gmail.com>
 <5638B208.1050502@turmel.org>
 <CAPpdf58x1eKXTKbvisQGV9KUsMRzEacSifaLLzQkX53YM5c6jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf58x1eKXTKbvisQGV9KUsMRzEacSifaLLzQkX53YM5c6jg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/11/15 00:36, o1bigtenor wrote:
> Mondo seems to be an interesting backup tool. Would you have any
> suggestions? (In the past I was backing up to 25 GB Bluray disks. Was
> in the process of setting up a NAS box (with ECC and NAS level drives)
> to be backup using rsync (I think). I don't want any more of these 2
> months without being able to get business done times if I can help it!!!

Somewhat off-topic for this list, but I would suggest some tool that you
can learn how to use it, is reliable, stable, easy to fix, and
well-supported. Personally, I use backuppc, I wouldn't suggest a simple
home-spun rsync copy, as there are lots of things to consider in backup
(eg, you want todays, yesterdays, etc... up to last month or more of
history for each file). You also want an easy restore process for a
single file, group of files, or the entire system.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
Ph: +61 2 8304 0000                            adam@websitemanagers.com.au
Fax: +61 2 8304 0001                            www.websitemanagers.com.au

