From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] md-linear: use struct_size() in kzalloc()
Date: Tue, 29 Jan 2019 11:22:54 -0600
Message-ID: <caff2263-fb7d-257c-f7f2-cca6c537f597@embeddedor.com>
References: <20190107174538.GA7255@embeddedor>
 <CAPhsuW7a_F_K1cJdrGHLhnuCdpeN365n1BG-QawmxKWaZajGeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW7a_F_K1cJdrGHLhnuCdpeN365n1BG-QawmxKWaZajGeA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <liu.song.a23@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

Friendly ping:

Who can take this?

Thanks
--
Gustavo

On 1/7/19 5:01 PM, Song Liu wrote:
> On Mon, Jan 7, 2019 at 10:35 AM Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
>>
>> One of the more common cases of allocation size calculations is finding the
>> size of a structure that has a zero-sized array at the end, along with memory
>> for some number of elements for that array. For example:
>>
>> struct foo {
>>     int stuff;
>>     void *entry[];
>> };
>>
>> instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);
>>
>> Instead of leaving these open-coded and prone to type mistakes, we can now
>> use the new struct_size() helper:
>>
>> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);
>>
>> This code was detected with the help of Coccinelle.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> 
>> ---
>>  drivers/md/md-linear.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
>> index d45c697c0ebe..5998d78aa189 100644
>> --- a/drivers/md/md-linear.c
>> +++ b/drivers/md/md-linear.c
>> @@ -96,8 +96,7 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
>>         int i, cnt;
>>         bool discard_supported = false;
>>
>> -       conf = kzalloc (sizeof (*conf) + raid_disks*sizeof(struct dev_info),
>> -                       GFP_KERNEL);
>> +       conf = kzalloc(struct_size(conf, disks, raid_disks), GFP_KERNEL);
>>         if (!conf)
>>                 return NULL;
>>
>> --
>> 2.20.1
>>
