#include <sstream>
#include "expression_graph.h"

using namespace std;

namespace marian {

Expr::Expr(ExpressionGraphPtr g, Chainable<Tensor>* chainable)
  : graph_(g), pimpl_(chainable) {
  graph_->stack()->push_back(chainable);    
}

Tensor Expr::val() {
  return pimpl_->val();
}

Tensor Expr::grad() {
    return pimpl_->grad();
}

ChainPtr Expr::node() {
    return pimpl_;
}

ExpressionGraphPtr Expr::graph() {
    return graph_;
}
  
Expr::operator ChainPtr() {
  return pimpl_;
}

std::string Expr::Debug() const
{
	stringstream strm;
	const Shape &shape = pimpl_->shape();
	strm << marian::Debug(shape);
	return strm.str();
}

///////////////////////////////////////////////////////
#include "tensor_operators.h"

void temp()
{
	std::vector<float> hVec({1,2,  4,3,  7,9,  7,3});
	thrust::device_vector<float> dVec(8);
	thrust::copy(hVec.begin(), hVec.end(), dVec.begin());
	float *data = hVec.data();
	gSoftMax<<<2, 4>>>(data, 2, 4);

}

ExpressionGraph::ExpressionGraph(int cudaDevice)
: stack_(new ChainableStack)
{
  std::srand (time(NULL));
  cudaSetDevice(0);

  temp();
}

}
