From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid6 recovery
Date: Mon, 23 Mar 2020 09:23:32 +0000
Message-ID: <5E788014.3080203@youngman.org.uk>
References: <CA+9eyijuUEJ7Y8BuxkKaZ=v8zbPpwixOezngPjtJzaLsBd+A4Q@mail.gmail.com>
 <5E75163B.2050602@youngman.org.uk>
 <CA+9eyigMV-E=FwtXDWZszSsV6JOxxFOFVh6WzmeH=OC3heMUHw@mail.gmail.com>
 <ab2a40b6-b4ab-9ff8-aef6-02d8cce8d587@youngman.org.uk>
 <CA+9eyig8U2Tzi1wF97k7eDu5vKg5Jc2sRXKaw0OCy7Cbc9HMog@mail.gmail.com>
 <c55be05d-22ee-4676-7878-5bf99ccc80f9@turmel.org>
 <CA+9eyiicKrPh9YTrGN5FjOU7zMVMqO3=8yGszWkV67fJxrtKrw@mail.gmail.com>
 <50fc13d2-bd5f-d3c3-09f6-f7274aeaf917@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50fc13d2-bd5f-d3c3-09f6-f7274aeaf917@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Glenn Greibesland <glenngreibesland@gmail.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 22/03/20 00:32, Phil Turmel wrote:
> However, there have been bugs in --force that would cause it to not
> assemble.  Also, I believe latest behavior for --re-add would not have
> damaged the metadata.

And note that the website does tell you always to use the latest version
of mdadm when trying to recover an array ... because it's linux-only
it's pretty easy to build from source if you have to.

Cheers,
Wol
