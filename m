From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Need to upgrade to latest stable mdadm version?
Date: Mon, 23 Jan 2006 17:58:11 +0400
Message-ID: <43D4E0F3.3070406@wasp.net.au>
References: <200601221241.54689.mlaks@verizon.net> <43D3C5A8.3070200@dgreaves.com> <200601230902.45171.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200601230902.45171.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell Laks wrote:

> It does not work with the debian sid 2.6.15 kernel. You were far more 
> observant than I. I thought that my 2 raids were working with the debian 
> 2.6.15 but in fact it one of the drives had failed out of the  array (thats 
> why it seemed to work, I hadn't slept enough...).
> 
> In fact your diagnosis is completely correct. I cannot get both sata_via and 
> sata_promise up at the same time, without timeout problems. 

I _hope_ this is just an anomaly as I have a production machine here with 2.6.10, 3 sata_pro6mise 
cards and using the on-board sata_via interface also.. I was planning on upgrading it to 2.6.15 or 
2.6.16 when it's released to gain the benefit of the new raid-5 error recovery patches.


-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
