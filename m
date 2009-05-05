From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [md PATCH 6/7] md: remove ability to explicit set an inactive
	array to 'clean'.
Date: Tue, 5 May 2009 10:04:13 -0700
Message-ID: <e9c3a7c20905051004l1324289dt7639e0196fe7b43@mail.gmail.com>
References: <20090504065540.11688.39505.stgit@notabene.brown>
	 <20090504065850.11688.1442.stgit@notabene.brown>
	 <e9c3a7c20905040927j1f587c91p5c4fc14c27563d3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20905040927j1f587c91p5c4fc14c27563d3d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 4, 2009 at 9:27 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sun, May 3, 2009 at 11:58 PM, NeilBrown <neilb@suse.de> wrote:
>> So just disable the use of 'clean' to activate an array.
>>
>> Signed-off-by: NeilBrown <neilb@suse.de>
>
> Reported-by: Rafal Marszewski <rafal.marszewski@intel.com>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
>

I think this should also be Cc: <stable@kernel.org> to get picked up
for the 2.6.27-stable series??
