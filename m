From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2.6.23-rc7 1/3] async_tx: usage documentation and
 developer notes
Date: Thu, 20 Sep 2007 20:46:04 -0700
Message-ID: <20070920204604.88ac48e2.randy.dunlap@oracle.com>
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
	<20070921012740.17157.49639.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070921012740.17157.49639.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org, yur@emcraft.com, saeed.bishara@gmail.com, shannon.nelson@intel.com
List-Id: linux-raid.ids

On Thu, 20 Sep 2007 18:27:40 -0700 Dan Williams wrote:

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Hi Dan,

Looks pretty good and informative.  Thanks.

(nits below :)


>  Documentation/crypto/async-tx-api.txt |  217 +++++++++++++++++++++++++++++++++
>  1 files changed, 217 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/crypto/async-tx-api.txt b/Documentation/crypto/async-tx-api.txt
> new file mode 100644
> index 0000000..48d685a
> --- /dev/null
> +++ b/Documentation/crypto/async-tx-api.txt
> @@ -0,0 +1,217 @@
> +		 Asynchronous Transfers/Transforms API
> +
> +1 INTRODUCTION
> +
> +2 GENEALOGY
> +
> +3 USAGE
> +3.1 General format of the API
> +3.2 Supported operations
> +3.2 Descriptor management

duplicate 3.2

> +3.3 When does the operation execute?
> +3.4 When does the operation complete?
> +3.5 Constraints
> +3.6 Example
> +
> +4 DRIVER DEVELOPER NOTES
> +4.1 Conformance points
> +4.2 "My application needs finer control of hardware channels"
> +
> +5 SOURCE
> +
> +---
> +
> +1 INTRODUCTION
> +
> +The async_tx api provides methods for describing a chain of asynchronous
> +bulk memory transfers/transforms with support for inter-transactional
> +dependencies.  It is implemented as a dmaengine client that smooths over
> +the details of different hardware offload engine implementations.  Code
> +that is written to the api can optimize for asynchronous operation and
> +the api will fit the chain of operations to the available offload
> +resources.
> +

I would s/api/API/g .

> +2 GENEALOGY
> +
[snip]

> +
> +3 USAGE
> +
> +3.1 General format of the API:
> +struct dma_async_tx_descriptor *
> +async_<operation>(<op specific parameters>,
> +		  enum async_tx_flags flags,
> +        	  struct dma_async_tx_descriptor *dependency,
> +        	  dma_async_tx_callback callback_routine,
> +		  void *callback_parameter);
> +
> +3.2 Supported operations:
> +memcpy       - memory copy between a source and a destination buffer
> +memset       - fill a destination buffer with a byte value
> +xor 	     - xor a series of source buffers and write the result to a
> +	       destination buffer
> +xor_zero_sum - xor a series of source buffers and set a flag if the
> +	       result is zero.  The implementation attempts to prevent
> +	       writes to memory
> +
> +3.2 Descriptor management:

duplicate 3.2

> +The return value is non-NULL and points to a 'descriptor' when the operation
> +has been queued to execute asynchronously.  Descriptors are recycled
> +resources, under control of the offload engine driver, to be reused as
> +operations complete.  When an application needs to submit a chain of
> +operations it must guarantee that the descriptor is not automatically recycled
> +before the dependency is submitted.  This requires that all descriptors be
> +acknowledged by the application before the offload engine driver is allowed to
> +recycle (or free) the descriptor.  A descriptor can be acked by:

can be acked by any of:   (?)

> +1/ setting the ASYNC_TX_ACK flag if no operations are to be submitted
> +2/ setting the ASYNC_TX_DEP_ACK flag to acknowledge the parent
> +   descriptor of a new operation.
> +3/ calling async_tx_ack() on the descriptor.
> +
> +3.3 When does the operation execute?:

Drop ':'

> +Operations do not immediately issue after return from the
> +async_<operation> call.  Offload engine drivers batch operations to
> +improve performance by reducing the number of mmio cycles needed to
> +manage the channel.  Once a driver specific threshold is met the driver

                               driver-specific

> +automatically issues pending operations.  An application can force this
> +event by calling async_tx_issue_pending_all().  This operates on all
> +channels since the application has no knowledge of channel to operation
> +mapping.
> +
> +3.4 When does the operation complete?:

drop ':'

> +There are two methods for an application to learn about the completion
> +of an operation.
> +1/ Call dma_wait_for_async_tx().  This call causes the cpu to spin while

s/cpu/CPU/g

> +   it polls for the completion of the operation.  It handles dependency
> +   chains and issuing pending operations.
> +2/ Specify a completion callback.  The callback routine runs in tasklet
> +   context if the offload engine driver supports interrupts, or it is
> +   called in application context if the operation is carried out
> +   synchronously in software.  The callback can be set in the call to
> +   async_<operation>, or when the application needs to submit a chain of
> +   unknown length it can use the async_trigger_callback() routine to set a
> +   completion interrupt/callback at the end of the chain.
> +
> +3.5 Constraints:
> +1/ Calls to async_<operation> are not permitted in irq context.  Other

s/irq/IRQ/g

> +   contexts are permitted provided constraint #2 is not violated.
> +2/ Completion callback routines can not submit new operations.  This

                                   cannot

> +   results in recursion in the synchronous case and spin_locks being
> +   acquired twice in the asynchronous case.
> +
> +3.6 Example:
> +Perform a xor->copy->xor operation where each operation depends on the
> +result from the previous operation:
> +
> +void complete_xor_copy_xor(void *param)
> +{
> +	printk("complete\n");
> +}
> +
> +int run_xor_copy_xor(struct page **xor_srcs,
[snip]

> +}
> +
> +See include/linux/async_tx.h for more information on the flags

end with '.'

> +See the ops_run_* and ops_complete_* routines drivers/md/raid5.c for more

                                                ^in

> +implementation examples.
> +
> +4 DRIVER DEVELOPMENT NOTES
> +4.1 Conformance points:
> +There are a few conformance points required in dmaengine drivers to
> +accommodate assumptions made by applications using the async_tx api:
> +1/ Completion callbacks are expected to happen in tasklet or process
> +   context
> +2/ dma_async_tx_descriptor fields are never manipulated in irq context
> +3/ Use async_tx_run_dependencies() in the descriptor clean up path to
> +   handle submission of dependent operations
> +
> +4.2 "My application needs finer control of hardware channels"
> +This requirement seems to arise from cases where a DMA engine driver is
> +trying to support device-to-memory DMA.  The dmaengine and async_tx
> +implementations were designed for offloading memory-to-memory
> +operations; however, there are some capabilities of the dmaengine layer
> +that can be used for platform specific channel management.  Platform

                        platform-specific                      Platform-

> +specific constraints can be handled by registering the application as a
> +'dma_client' and implementing a 'dma_event_callback' to apply a filter
> +to the available channels in the system.  Before showing how to
> +implement a custom dma_event callback some background of dmaengine's
> +client support is required.
> +
> +The following routines in dmaengine support multiple clients requesting
> +use of a channel:
> +- dma_async_client_register(struct dma_client *client)
> +- dma_async_client_chan_request(struct dma_client *client)
> +
> +dma_async_client_register takes a pointer to an initialized dma_client
> +structure.  It expects that the 'event_callback' and 'cap_mask' fields
> +are already initialized.
> +
> +dma_async_client_chan_request triggers dmaeninge to notify the client of
> +all channels that satisfy the capability mask.  It is up to the client's
> +event_callback routine to track how many channels the client needs and
> +how many it is currently using.  The dma_event_callback routine returns a
> +dma_state_client code to let dmaengine know the status of the
> +allocation.
> +
> +Below is the example of how to extend this functionality for platform

                                                                platform-

> +specific filtering of the available channels beyond the standard
> +capability mask:
> +
> +static enum dma_state_client
> +my_dma_client_callback(struct dma_client *client,
> +			struct dma_chan *chan, enum dma_state state)
> +{
> +	. . .
> +}
> +
> +5 SOURCE
> +drivers/dma/dmaengine.c: offload engine channel management routines
> +drivers/dma/: location for offload engine drivers
> +crypto/async_tx/async_tx.c: async_tx interface to dmaengine and common code
> +crypto/async_tx/async_memcpy.c: copy offload
> +crypto/async_tx/async_memset.c: memory fill offload
> +crypto/async_tx/async_xor.c: xor offload
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
