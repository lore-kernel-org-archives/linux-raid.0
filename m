From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: SMART detects pending sectors; take offline?
Date: Fri, 5 Jan 2018 13:25:58 +0800
Message-ID: <85891f3d-eaf6-9127-b55a-dea9d21d180b@fnarfbargle.com>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <fcb32200-19f7-5513-24a0-70ca15ca6297@shenkin.org>
 <7bf0a71e-6cb7-59bc-695b-54ed6b08112b@turmel.org>
 <d86c80ba-7703-1591-7816-00d0d9408386@shenkin.org>
 <a5487193-24e6-879b-bd09-caf5f75c8fcc@turmel.org>
 <05e4489d-98ea-4d12-02d6-f13a98e3d5d4@shenkin.org>
 <201ea04e-1a03-fc83-c31c-146b50bb8624@thelounge.net>
 <47ec07c3-25ae-9595-78a2-8420c106f2a0@fnarfbargle.com>
 <20497c70-140d-c4dd-0201-816477bd467f@shenkin.org>
 <14f1fce1-2959-e051-f7c8-1d98951d744a@fnarfbargle.com>
 <07170cf8-d951-013b-7e67-eee54aa60c65@shenkin.org>
 <61e91b55-5b96-143e-15c8-4a320f89eeb2@turmel.org>
 <ae183814-248b-2d45-8074-85787fcd0d61@shenkin.org>
 <6572ed42-8559-84eb-0468-7823786c3001@turmel.org>
 <7bce6228-0695-ff30-7cc0-60486be128ff@shenkin.org>
 <c24ffbc6-6ba6-ef04-76f3-2217fe5f4926@shenkin.org>
 <97c75be5-1988-0e66-0d50-f06188418b3b@fnarfbargle.com>
 <cd34964a-e269-6dd7-3c36-73a9c8dbb61d@shenkin.org>
 <bc2e597b-1585-f9b6-ef1a-f1aa3e1f39a0@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bc2e597b-1585-f9b6-ef1a-f1aa3e1f39a0@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Phil Turmel <philip@turmel.org>, Reindl Harald <h.reindl@thelounge.net>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/01/18 13:20, Brad Campbell wrote:

> You re-wrote Sectors 5857843312+7 on the disk.

> Add those two and we get 5844545408 sectors. So if my maths is any good
> you wrote a block 13297904 sectors from the end of the data area.

I can't believe I did that. No, you wrote a block ~6M *after* the data 
area and you should be fine.

I'm going to go and write a letter of apology to my primary school maths 
teacher now.


-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
