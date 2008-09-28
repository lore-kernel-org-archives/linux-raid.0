From: Keld =?utf-8?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Faster read performance DURING (?) resync on raid10
Date: Sun, 28 Sep 2008 04:23:18 +0200
Message-ID: <20080928022318.GA5634@rap.rap.dk>
References: <19666016.post@talk.nabble.com> <18652.25227.7530.435789@notabene.brown> <104f2a240809261619m2512bddem11ea7960d86df2ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <104f2a240809261619m2512bddem11ea7960d86df2ff@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Zetterman <daniel.zetterman@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 27, 2008 at 01:19:50AM +0200, Daniel Zetterman wrote:
> I've done some more tests and here are the results:
> 
> # bonnie++ during resync with readahead set to 512 (encrypted raid10)
> kpax,4G,,,77308,21,34585,17,,,82073,33,384.8,1,,,,,,,,,,,,,

It would be nice to know which layout (near,far,offset)
that you are using for the test. The expected results are quite
dependent on this.

best regards
keld
