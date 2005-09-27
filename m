From: Brad Campbell <brad@wasp.net.au>
Subject: Re: maximum size
Date: Tue, 27 Sep 2005 17:28:19 +0400
Message-ID: <433948F3.4000101@wasp.net.au>
References: <43394753.9040107@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43394753.9040107@bppiac.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@bppiac.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Farkas Levente wrote:
> hi,
> i'd been already asked, but don't get any answer. what is the maximum 
> size of a raid5 and raid5 partition in kerenel 2.6? i try to find the 
> answer but found only kernel 2.4 info.
> thanks in advance.

Don't know about max sizes, but I have a 2.1TB raid-5 and a 3TB raid-6 here. No issues at all.
Had to move to 2.6 as 2.4 did not support > 2TB filesystems

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
