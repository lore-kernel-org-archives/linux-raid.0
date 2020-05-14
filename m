From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] mdcheck: Log when done
Date: Thu, 14 May 2020 11:09:16 -0400
Message-ID: <bbb4c492-4fa3-ae68-d045-976c102ab2b3@trained-monkey.org>
References: <20200513131646.16357-1-pmenzel@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200513131646.16357-1-pmenzel@molgen.mpg.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>, Jes Sorensen <Jes.Sorensen@gmail.com>
Cc: Donald Buczek <buczek@molgen.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/13/20 9:16 AM, Paul Menzel wrote:
> From: Donald Buczek <buczek@molgen.mpg.de>
> 
> Currently mdcheck (when called with `--duration`) logs only the
> beginning of the check, the pausing and the continuation but not the
> completion.
> 
> So, log the completion, too, so that it can be determined how long the
> raid check took.
> 
>     2020-05-08T18:00:02+02:00 deadpool root: mdcheck start checking /dev/md0
>     2020-05-08T18:00:02+02:00 deadpool root: mdcheck start checking /dev/md1
>     2020-05-09T15:32:04+02:00 deadpool root: mdcheck finished checking /dev/md1
>     2020-05-09T17:38:04+02:00 deadpool root: mdcheck finished checking /dev/md0
> 
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>

Applied!

Thanks,
Jes
