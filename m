From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: SMART detects pending sectors; take offline?
Date: Thu, 21 Dec 2017 12:38:22 +0100
Message-ID: <201ea04e-1a03-fc83-c31c-146b50bb8624@thelounge.net>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
 <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
 <afaa1020-652d-911c-16e0-12ed87f2197a@shenkin.org>
 <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
 <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org>
 <59DF4B80.5010807@youngman.org.uk>
 <ecbbf0ae-3bf8-fe66-79e1-e8207bc09dcc@turmel.org>
 <5b28b0fc-5e4d-9ac3-9a82-7e36f25c5108@shenkin.org>
 <CAK2H+ecT1Psph5Wm9LrPgYOba6PHKzAs55H1LWiqLD+kaBUQZQ@mail.gmail.com>
 <CACsGCyQGZxhfT1A_ojXaBRvB4wgNOH7fqqh8afsQksAeGdKmjg@mail.gmail.com>
 <CACsGCyS9-K4ZJPKauRZkGFRPd0cvShYLViE87i47=RCY1UkbnQ@mail.gmail.com>
 <fcb32200-19f7-5513-24a0-70ca15ca6297@shenkin.org>
 <7bf0a71e-6cb7-59bc-695b-54ed6b08112b@turmel.org>
 <d86c80ba-7703-1591-7816-00d0d9408386@shenkin.org>
 <a5487193-24e6-879b-bd09-caf5f75c8fcc@turmel.org>
 <05e4489d-98ea-4d12-02d6-f13a98e3d5d4@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05e4489d-98ea-4d12-02d6-f13a98e3d5d4@shenkin.org>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Phil Turmel <philip@turmel.org>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 21.12.2017 um 12:28 schrieb Alexander Shenkin:
> Hi all,
> 
> Reporting back after changing the hangcheck timer to 180 secs and 
> re-running checkarray.  I got a number of rebuild events (see syslog 
> excerpts below and attached), and I see no signs of the hangcheck issue 
> in dmesg like I did last time.
> 
> I'm still getting the SMART OfflineUncorrectableSector and 
> CurrentPendingSector errors, however.  Should those go away if the 
> rewrites were correctly carried out by the drive?  Any thoughts on next 
> steps to verify everything is ok?

OfflineUncorrectableSector unlikely can go away

CurrentPendingSector
https://kb.acronis.com/content/9133
