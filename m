From: Brad Campbell <brad@wasp.net.au>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Tue, 16 Nov 2004 10:13:47 +0400
Message-ID: <41999A9B.2000907@wasp.net.au>
References: <200411132039.iADKdDN07474@www.watkins-home.com> <41968282.6060306@dgreaves.com> <4198DF79.8080809@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4198DF79.8080809@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Guy <bugzilla@watkins-home.com>, =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mru@inprovide.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:

> Now all I need is SMART through libata.

If you are using a UP system, grab the patches from Jeff's libata-dev tree and have at it.
I have been beating it hard on 14 drives here on a loaded working server for weeks and have not 
managed to toast anything yet. It's great being able to keep tabs on the remaining whirly bits and 
hopefully get an early warning before they expire.

(Fingers crossed. 12 of them are Maxtor Maxline-II drives but all sit between 35 & 40 deg C)

Brad
