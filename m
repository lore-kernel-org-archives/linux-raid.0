From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RAID creation resync behaviors
Date: Thu, 4 May 2017 23:20:12 +0800
Message-ID: <38474044-df35-b214-ca9c-35d9debe92fe@fnarfbargle.com>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
 <20170503235856.GA9698@metamorpher.de>
 <20170504022258.eov6xh2zwtbfvcch@kernel.org>
 <20170504075551.GA3929@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170504075551.GA3929@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

On 04/05/17 15:55, Andreas Klauer wrote:
> On Wed, May 03, 2017 at 07:22:58PM -0700, Shaohua Li wrote:
>>
>> Unfortunately not all SSD return zero after trim.
>>
>
> For example? I was under the impression that pretty much all of them do.

Pretty much every Samsung except the 840 Pro it seems. Certainly my 830s 
and 850s don't.

> Even the ones that don't advertize it returned zero after trim for me.

You got lucky.

