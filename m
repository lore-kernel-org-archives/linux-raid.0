From: Pol Hallen <raid1@fuckaround.org>
Subject: Re: Unstable speed or correct?
Date: Thu, 9 Jun 2011 13:52:07 +0200
Message-ID: <201106091352.07804.raid1@fuckaround.org>
References: <201106090909.23757.raid2@fuckaround.org> <BANLkTinrqCiyj+Z2zTAfS9Ar8MxUTn7Khw@mail.gmail.com> <201106091325.54782.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201106091325.54782.raid1@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

init 1 raid 6 performance:

http://fuckaround.org/nuvola/?p=17

iostat md0 -x 1:

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz 
avgqu-sz   await  svctm  %util
md0               0.00     0.00    0.00    0.00     0.00     0.00     0.00     
0.00    0.00   0.00   0.00

:-(((

Pol
