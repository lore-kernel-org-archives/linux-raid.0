From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH 2/2] mdcheck: improve cleanup
Date: Tue, 10 Oct 2017 16:42:51 -0400
Message-ID: <6ebae49b-b6a0-dff1-c88a-812d81165002@gmail.com>
References: <87h8vd12mn.fsf@notabene.neil.brown.name>
 <87d16112kv.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d16112kv.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/05/2017 09:34 PM, NeilBrown wrote:
> 
> We should remove the tmp file on signals as well as on exit.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>   misc/mdcheck | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes

