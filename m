From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [md PATCH 6/7] md: remove ability to explicit set an inactive
	array to 'clean'.
Date: Mon, 4 May 2009 09:27:14 -0700
Message-ID: <e9c3a7c20905040927j1f587c91p5c4fc14c27563d3d@mail.gmail.com>
References: <20090504065540.11688.39505.stgit@notabene.brown>
	 <20090504065850.11688.1442.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090504065850.11688.1442.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 3, 2009 at 11:58 PM, NeilBrown <neilb@suse.de> wrote:
> Being able to write 'clean' to an 'array_state' of an inactive array
> to activate it in 'clean' mode is both unnecessary and inconvenient.
>
> It is unnecessary because the same can be achieved by writing
> 'active'. =A0This activates and array, but it still remains 'clean'
> until the first write.
>
> It is inconvenient because writing 'clean' is more often used to
> cause an 'active' array to revert to 'clean' mode (thus blocking
> any writes until a 'write-pending' is promoted to 'active').
>
> Allowing 'clean' to both activate an array and mark an active array a=
s
> clean can lead to races: =A0One program writes 'clean' to mark the
> active array as clean at the same time as another program writes
> 'inactive' to deactivate (stop) and active array. =A0Depending on whi=
ch
> writes first, the array could be deactivated and immediately
> reactivated which isn't what was desired.
>
> So just disable the use of 'clean' to activate an array.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reported-by: Rafal Marszewski <rafal.marszewski@intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
