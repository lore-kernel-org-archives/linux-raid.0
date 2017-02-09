From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH 1/5] MD: attach data to each bio
Date: Thu, 9 Feb 2017 00:09:26 +0000
Message-ID: <589BB336.1040203@youngman.org.uk>
References: <cover.1486485935.git.shli@fb.com>
 <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com>
 <589ADFEC.1070902@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <589ADFEC.1070902@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: khlebnikov@yandex-team.ru, hch@lst.de, neilb@suse.com
List-Id: linux-raid.ids

On 08/02/17 09:07, Guoqing Jiang wrote:
> 
> 
> On 02/08/2017 12:55 AM, Shaohua Li wrote:
>> Currently MD is rebusing some bio fields. To remove the hack, we attach
>> extra data to each bio. Each personablity can attach extra data to the
>> bios, so we don't need to rebuse bio fields.
> 
> rebuse? Maybe it should be reuse, or abuse.
> 
imho abuse

also
c/personablity/personality/

Cheers,
Wol

