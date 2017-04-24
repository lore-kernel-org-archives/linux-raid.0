From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Recover array after I panicked
Date: Mon, 24 Apr 2017 10:09:36 +0800
Message-ID: <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com>
 <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org>
 <20170423154240.GA3494@metamorpher.de>
 <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/04/17 03:21, Patrik Dahlström wrote:

> I just thought of something: since /dev/sdf is a completely new disk,
> shouldn't I be able to locate the starting point by looking at how much
> of the new disk is filled. It comes filled with zeros from factory, right?

Pretty close. You should also be able to see how the reshape worked 
(front to back, back to front) and you should get a pretty good idea of 
the data-offset by the gap between the superblock and the data.

I must say I'm having trouble imagining a more difficult recovery 
scenario, so at least you present an interesting challenge.

There's a lot to be said for the old "Don't panic" mantra, but hindsight 
is always 20/20.
