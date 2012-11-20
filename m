From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Re: Where can i download mdadm 3.3
Date: Tue, 20 Nov 2012 08:02:26 -0300
Message-ID: <CAGmni9oWcBYNyfKW4YQUPORRgz+hPM1tQ_jzWrOiNyZV2UmPEA@mail.gmail.com>
References: <CAGmni9ozPTrqeg+RLBu=J8NEqqK95nwf0ymK7qA7DgpZNRHX=A@mail.gmail.com>
 <20121120122622.34f9bacd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121120122622.34f9bacd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil !
[]'s
Salatiel


On Mon, Nov 19, 2012 at 10:26 PM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 18 Nov 2012 10:42:22 -0300 Salatiel Filho <salatiel.filho@gmail.com>
> wrote:
>
>> Hi guys, i will be building a few arrays very soon and i'd like to
>> test the badblock feature and the replaceable feature, but i haven`t
>> found where i can download the source of mdadm 1.3. Where can i get it
>> ?
>>
> You can't.  3.3 doesn't exist yet.
>
> However
>   git clone git://neil.brown.name/mdadm
>   cd mdadm
>   make
>
> will get you code that supports bad blocks and replaceable devices.
>
> Alternately you can get a tar file at
>
>    http://git.neil.brown.name/git?p=mdadm.git;a=snapshot;h=master
>
> NeilBrown
